-- source https://sqlzoo.net/wiki/More_JOIN_operations

--Give year of 'Citizen Kane'.
SELECT yr FROM movie
 WHERE title = 'Citizen Kane'

--List all of the Star Trek movies, include the id, title and
-- yr (all of these movies include the words Star Trek in the title). 
-- Order results by year.
SELECT id, title, yr FROM movie
 WHERE title LIKE 'Star Trek%'
 ORDER BY yr

-- What id number does the actor 'Glenn Close' have?
SELECT DISTINCT id FROM actor
 JOIN casting ON (id=actorid)
  WHERE actor.name = 'Glenn Close'

-- What is the id of the film 'Casablanca'
SELECT id FROM movie
 WHERE title = 'Casablanca'

--Obtain the cast list for 'Casablanca'.
SELECT name FROM actor
 JOIN casting ON (id=actorid)
  WHERE movieid = '27'

-- Obtain the cast list for the film 'Alien'
SELECT name FROM actor
 JOIN casting ON (id=actorid)
 WHERE movieid = '35'

--List the films in which 'Harrison Ford' has appeared
SELECT title FROM movie
 JOIN casting ON (movie.id=movieid)
 JOIN actor ON (casting.actorid=actor.id)
 WHERE actor.name = 'Harrison Ford'

-- List the films where 'Harrison Ford' has appeared - but not in
-- the starring role. [Note: the ord field of casting gives the position of the actor.
SELECT title FROM movie
 JOIN casting ON (movie.id=movieid)
 JOIN actor ON (casting.actorid=actor.id)
 WHERE actor.name = 'Harrison Ford'
  AND casting.ord > 1

--List the films together with the leading star for all 1962 films.
SELECT title, actor.name FROM movie
 JOIN casting ON (movie.id = movieid)
 JOIN actor ON (actor.id=actorid)
 WHERE ord = 1 AND yr = 1962

--Which were the busiest years for 'Rock Hudson', show the year and the number of movies 
--he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 1

--List the film title and the leading actor for all of the films 
--'Julie Andrews' played in.
SELECT title, actor.name FROM movie
JOIN casting ON (movie.id = movieid AND ord = 1)
JOIN actor ON (actor.id = actorid)
WHERE movieid IN (SELECT movieid FROM casting
                  WHERE actorid IN (
                        SELECT id FROM actor
                        WHERE name='Julie Andrews'))

-- Obtain a list, in alphabetical order, of actors who've 
--had at least 15 starring roles.
SELECT DISTINCT name FROM actor
 JOIN casting ON (actor.id = actorid)
 JOIN movie ON (movie.id = movieid)
 WHERE actorid in(
   SELECT actorid
   FROM casting 
   WHERE ord = 1 
   GROUP BY actorid HAVING COUNT(ord) >= 15
 )

--List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) AS act FROM movie
 JOIN casting ON (id=movieid)
 WHEre yr = 1978
 GROUP BY title
 ORDER BY act desc, title


--List all the people who have worked with 'Art Garfunkel'.
SELECT name FROM actor
 JOIN casting ON (id=actorid)
  WHERE name != 'Art Garfunkel' AND movieid IN 
                    (SELECT movieid FROM casting
                      WHERE actorid IN 
                                      (SELECT id FROM actor WHERE 
                                      name='Art Garfunkel')
                      )
