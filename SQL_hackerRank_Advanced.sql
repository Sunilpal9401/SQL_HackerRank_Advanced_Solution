use hackerrank_advance;

--Creating Table Contestants
create table contestants
(  id int identity(1,1) not null,
   personName nvarchar(10) );

   --Inserting Values
   insert into contestants ( personName )
    values ( 'Sunil' ), ('Shankar'), ('Gaurav' ), ('Alankrit');

	--Creating Table attempts
	create table attempts
( id int identity(1,1) not null,
  contestantid int not null,
  score int not null );

  --Inserting Values
  insert into attempts ( contestantid, score )
   values
     ( 1, 72 ), ( 1, 88 ), (1, 81 ),
     ( 2, 83 ), ( 2, 88 ), (2, 79), (2,86),
     ( 3, 94 ),
     ( 4, 79 ), (4, 87);

	 drop table attempts;
	 --Displaying all data from both the tables

	 Select * from contestants;
	 Select * from attempts;

	 --Each contestants best score which is a simple maximum of the score per contestant.

	 select
        contestantid,
        max( score ) highestScore
    from
        attempts
    group by
        contestantid;

		--The result of the above query is the base of the final ranking.
		--So I have put that query as the FROM source. So instead of a table, the from is the result of the above query
		--which I have aliased "Pre" for the pre-aggregation per contestant.

		select
        ContestantID,
        c.personName,
        DENSE_RANK() OVER ( order by HighestScore DESC ) as FinalRank
    from
        (select
                contestantid,
                max( score ) highestScore
            from
                attempts
            group by
                contestantid ) pre
            JOIN Contestants c
                on pre.contestantid = c.id;

				--Now, if you only wanted a limit such as the top 3 ranks and you actually had 15+ competitors,
				--just wrap this up one more time where a where clause


				select * from
(
select
        ContestantID,
        c.personName,
        DENSE_RANK() OVER ( order by HighestScore DESC ) as FinalRank
    from
        (select
                contestantid,
                max( score ) highestScore
            from
                attempts
            group by
                contestantid ) pre
            JOIN Contestants c
                on pre.contestantid = c.id ) dr
    where
        dr.FinalRank < 3;