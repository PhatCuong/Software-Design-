# Programming Exercise - Group 6

## Contributors

- 14547 - ChocolateOverflow (Project Leader, Java.API, UI Leader)
- 13872 - duchai9109 (Java.DB)
- 13948 - Noe315 (UI)
- 13886 - QuanTran4139 (UI)
- 15124 - TranPhanPhucLong (UI)
- 13298 - bacxhoang (DB Leader)
- 16052 - NguyenGiaKimThien (DB)

## Installing the application

### Database

Go to `/database`, log into MySQL, and source `init.sql`.

### Web applications

1. Run `mvn clean compile install`
2. Copy `target/Questionnaire*.war` to `path/to/tomcat/webapps/Questionnaire.war` (rename to remove the extra string in the middle)

## Configuration

To change the database name, replace `vgu6` with your database name in the following files:

- `/database/init.sql`
- `/src/main/java/com/vgu/sqm/questionnaire/database/Database.java`

JWT is set to use HMAC using SHA-512. To change the algorithm, replace `HS512` with the desired algorithm in `/src/main/java/com/vgu/sqm/questionnaire/auth/JwtHandler.java`

Parameter names for the API (e.g. `pid`, `mid`) are set in `/src/main/java/com/vgu/sqm/questionnaire/api/ResourceApi.java` as `p_` variables. To change the strings identifying the parameters for the API, change those `p_` variables.
