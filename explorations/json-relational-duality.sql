  SELECT JSON {'name' : d.forename||' '||d.surname,
               'nationality'   : d.nationality,
               'birthdate' : d.dob,
               'id' : driverid,
               'results' :
                 [ SELECT JSON {'position' : r.position,
                                'points'   : r.points 
                               , 'race' : [ select JSON {'circuit': c.name , 'race_date': rc.race_date } 
                                            from races rc join circuits c on rc.circuitid = c.circuitid
                                            where r.raceid =  rc.raceid 
                                          ]
                                }
                     FROM results r  
                     WHERE r.driverid = d.driverid 
                 ]
               }
  FROM drivers d ;



CREATE OR REPLACE
JSON RELATIONAL DUALITY VIEW f1_driver_results AS
  SELECT JSON {'name' : d.surname,
               'nationality'   : d.nationality,
               'birthdate' : d.dob,
               'id' : driverid,
               'results' :
                 [ SELECT JSON {'position' : r.position,
                                'points'   : r.points ,
                                'id': r.resultid
                                --, 'race' : [ select JSON {'circuit': rc.circuitid , 'id':rc.raceid  } from races rc where r.raceid =  rc.raceid ]
                                }
                     FROM results r 
                     WHERE r.driverid = d.driverid 
                 ]
               }
  FROM drivers d ;


