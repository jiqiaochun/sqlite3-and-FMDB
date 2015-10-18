//sine_id
@"SELECT * FROM t_statuses WHERE idstr > ? AND access_token = ? ORDER BY idstr DESC LIMIT 20;"

//max_id
@"SELECT * FROM t_statuses WHERE idstr <= ? AND access_token = ? ORDER BY idstr DESC LIMIT 20;"

//两个都不为真
"SELECT * FROM t_statuses WHERE access_token = ? ORDER BY idstr DESC LIMIT 20;"


//保存的时候的代码

@"INSERT INTO t_statuses(idstr, dict, access_token) VALUES(?, ?, ?);"


//创建表的sql语句

@"CREATE TABLE IF NOT EXISTS t_statuses(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, idstr TEXT NOT NULL, dict BLOB NOT NULL, access_token TEXT NOT NULL);"