DROP DATABASE IF EXISTS vgu6;
CREATE DATABASE vgu6;
USE vgu6;

source schemas/01_tables_def.sql;
source StoredProcedures/GetTotalClassesSize.sql;
source StoredProcedures/GetClassOptions.sql;
source StoredProcedures/AllDumpingProcedure.sql;
source StoredProcedures/AllAddingProcedure.sql;
source StoredProcedures/AllDeleteProcedure.sql;
source StoredProcedures/AllGetProcedure.sql;
source StoredProcedures/GetQuestionnaireCount.sql;
source StoredProcedures/AccessControl.sql;
source StoredProcedures/GetComments.sql;
source Tests/Testing_dataset.sql;
source Tests/TestAccounts.sql;
