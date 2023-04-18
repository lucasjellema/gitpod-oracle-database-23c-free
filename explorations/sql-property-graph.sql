CREATE MATERIALIZED VIEW tables_mv
BUILD IMMEDIATE 
REFRESH FORCE
ON DEMAND
AS 
select table_name
from   user_tables
/

CREATE MATERIALIZED VIEW foreign_keys_mv
BUILD IMMEDIATE 
REFRESH FORCE
ON DEMAND
AS 
SELECT fk.table_name referencing_table
,      fk.constraint_name referencing_constraint
,      fk.status
,      pk.table_name referenced_table
,      pk.constraint_name referenced_constraint
,      pk.constraint_type referenced_constraint_type
FROM   user_constraints fk 
JOIN   user_constraints pk ON fk.r_constraint_name = pk.constraint_name
WHERE fk.constraint_type = 'R'
/

CREATE or replace
PROPERTY GRAPH table_references_graph
  VERTEX TABLES (
    tables_mv as tables KEY (table_name)
      LABEL database_table
        PROPERTIES (table_name )
  )
  EDGE TABLES (
    foreign_keys_mv as foreign_keys KEY (referencing_constraint)
      SOURCE KEY (referencing_table) REFERENCES tables(table_name)
      DESTINATION KEY (referenced_table) REFERENCES tables(table_name)
      LABEL foreign_key
      PROPERTIES (referencing_constraint as constraint_name, status as foreign_key_status, referenced_constraint_type )
  );

-- self referencing foreign keys

SELECT * FROM GRAPH_TABLE (table_references_graph
  MATCH (a IS database_table) -[fk IS foreign_key]-> (b IS database_table)
  WHERE a.table_name = b.table_name
  COLUMNS (a.table_name, fk.constraint_name)
);

-- two tables who reference the same (common) table
SELECT * FROM GRAPH_TABLE (table_references_graph
  MATCH (a IS database_table) -[fk IS foreign_key]-> (b IS database_table) <-[fk2 IS foreign_key]- ( c IS database_table)
  WHERE a.table_name != c.table_name
  COLUMNS (a.table_name as table_one, fk.constraint_name as fk_one, b.table_name as common_table , fk2.constraint_name as fk_two, c.table_name as table_two)
)
order by common_table
;


-- two foreign keys from one table to another?

SELECT * FROM GRAPH_TABLE (table_references_graph
  MATCH (a IS database_table) -[fk IS foreign_key]-> (b IS database_table) <-[fk2 IS foreign_key]- ( c IS database_table)
  WHERE a.table_name = c.table_name and fk.constraint_name != fk2.constraint_name
  COLUMNS (a.table_name as table_one, fk.constraint_name as fk_one, b.table_name as common_table , fk2.constraint_name as fk_two, c.table_name as table_two)
)
order by common_table
;

grantparents

SELECT * FROM GRAPH_TABLE (table_references_graph
MATCH (a IS database_table) -[fk IS foreign_key]-> (b IS database_table) -[fk2 IS foreign_key]-> ( c IS database_table)
 COLUMNS (a.table_name as child_table, b.table_name as parent_table , c.table_name as grandparent_table)
)
order by grandparent_table
;
