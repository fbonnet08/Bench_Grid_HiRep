

drop table if exists BenchResults;
create table if not exists BenchResults(
    bench_id INTEGER PRIMARY KEY AUTOINCREMENT,
    machine_name varchar(50),
    test_id int,
    date_id int
);

drop table if exists DateTable;
create table if not exists
    DateTable(
        date_id INT,
        date_column DATE,
        time_column TIME,
        timestamp_with_tz_column VARCHAR(50),
        bench_id INT NOT NULL,
        PRIMARY KEY(date_id),
        UNIQUE(bench_id),
        FOREIGN KEY(bench_id) REFERENCES BenchResults(bench_id)
);

drop table if exists Test;
create table if not exists Test(
        test_id integer primary key,
        test_name varchar(50),
        test_type varchar(50),
        representation varchar(50),
        bench_id INT NOT NULL,
        date_id int not null,
        unique(bench_id, date_id),
        foreign key(test_id) references BenchResults(test_id),
        foreign key(date_id) references BenchResults(date_id)
);
