sqlserver::v2019::linux { "SQL2019Linux":
  sa_password => 'TestPassword1!',
  mssql_product_id => 'evaluation',
} 
->
sqlserver::sqlcmd::sqlquery {'Test SQL Query':
  server   => 'localhost',
  query    => 'USE master; CREATE DATABASE [testdb];',
  unless   => "IF (DB_ID('testdb') IS NULL) AND (NOT EXISTS (SELECT * FROM sys.availability_groups WHERE [name] = 'testdb')) raiserror ('Database already exists',1,1);",
  username => 'sa',
  password => 'TestPassword1!'
}
