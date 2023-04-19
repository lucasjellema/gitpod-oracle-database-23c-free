-- team mates 
-- shared podium (in Monaco)
-- see http://ergast.com/mrd/ for details on data model

-- who won a home grand prix? (need to map driver.nationality to circuit.country)
-- German, British, American, Dutch 
-- Germany, UK, USA, Netherlands


driver => result (position, points, laps) => race (year, date) => circuit 
                                                               => season
                 => constructor


CREATE or replace
PROPERTY GRAPH formula_one_graph
  VERTEX TABLES (
    drivers KEY (driverid)
      LABEL driver
        PROPERTIES (forename||' '||surname as name, nationality )
    , races KEY (raceid)
      LABEL race
        PROPERTIES (year, race_date )
    , circuits KEY (circuitid)
      LABEL circuit
        PROPERTIES (circuitid, name, country, alt as altitude, location )
  )
  EDGE TABLES (
    results KEY (resultid)
      SOURCE KEY (driverid) REFERENCES drivers(driverid)
      DESTINATION KEY (raceid) REFERENCES races(raceid)
      LABEL result
      PROPERTIES (position, rank as fastest_lap_rank, points)
  , races as hostings KEY (raceid)
      SOURCE KEY (raceid) REFERENCES races(raceid)
      DESTINATION KEY (circuitid) REFERENCES circuits(circuitid)
      LABEL hosted_by
      PROPERTIES (race_date)
  );


-- rank = overall place of fastest laptime compared to other drivers' fastest laptimes
-- position = rank in final standings
-- driver_number is the number on the race car

-- with whom has Max Verstappen shared the podium

SELECT distinct driver_one, driver_two FROM GRAPH_TABLE (formula_one_graph
  MATCH (a IS driver where a.name = 'Max Verstappen') -[b IS result where b.position <= 3]-> (c IS race) <-[d is result where d.position <= 3]- (e IS driver)  
  WHERE NOT VERTEX_EQUAL(a,e)
  COLUMNS (a.name as driver_one, e.name as driver_two, c.year)
);

-- with whom and how often has Max Verstappen shared the podium

SELECT driver_two, count(*) how_often FROM GRAPH_TABLE (formula_one_graph
  MATCH (a IS driver where a.name = 'Max Verstappen') -[b IS result where b.position <= 3]-> (c IS race) <-[d is result where d.position <= 3]- (e IS driver)  
  WHERE NOT VERTEX_EQUAL(a,e)
  COLUMNS (a.name as driver_one, e.name as driver_two, c.year)
)
group by driver_two
order by how_often desc
;

-- which drivers from the same country have shared the podium and where?

SELECT distinct driver_one, driver_two, race_date, nationality FROM GRAPH_TABLE (formula_one_graph
  MATCH (a IS driver ) -[b IS result where b.position <= 3]-> (c IS race) <-[d is result where d.position <= 3]- (e IS driver)  
  WHERE NOT VERTEX_EQUAL(a,e) and a.nationality = e.nationality
  COLUMNS (a.nationality, a.name as driver_one, e.name as driver_two, c.race_date)
);

-- which drivers from the same country have shared the podium and where (on which circuit)?
SELECT distinct driver_one, driver_two, race_date, nationality , circuit FROM GRAPH_TABLE (formula_one_graph
  MATCH (a IS driver ) -[b IS result where b.position <= 3]-> (c IS race) <-[d is result where d.position <= 3]- (e IS driver) 
  ,     (c IS race) -[f is hosted_by]-> (g IS circuit) 
  WHERE NOT VERTEX_EQUAL(a,e) and a.nationality = e.nationality
  COLUMNS (a.nationality, a.name as driver_one, e.name as driver_two, c.race_date, g.name as circuit)
);

-- which nationalities have ever had two or more drivers on the podium?
SELECT distinct nationality FROM GRAPH_TABLE (formula_one_graph
  MATCH (a IS driver ) -[b IS result where b.position <= 3]-> (c IS race) <-[d is result where d.position <= 3]- (e IS driver)  
  WHERE NOT VERTEX_EQUAL(a,e) and a.nationality = e.nationality
  COLUMNS (a.nationality, a.name as driver_one, e.name as driver_two, c.race_date)
);


-- who won twice on the same day in the year?
SELECT * FROM GRAPH_TABLE (formula_one_graph
  MATCH (a IS driver ) -[b IS result where b.position = 1]-> (c IS race)
  ,     (a IS driver ) -[d IS result where d.position = 1]-> (e IS race)
  WHERE NOT VERTEX_EQUAL(c,e) and to_char(c.race_date,'DDMM') = to_char(e.race_date,'DDMM')
  COLUMNS (a.name as driver_one, c.race_date as race_date1 , e.race_date as race_date2)
);

