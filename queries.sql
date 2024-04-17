-- 1) Среднее количество картин на выставку
SELECT AVG(paintings_per_exhibition) AS avg_paintings_per_exhibition
FROM (SELECT ExhibitionID, COUNT(*) AS paintings_per_exhibition
      FROM Exhibition_Painting
      GROUP BY ExhibitionID) AS subquery;

-- 2) Все авторы у которых картины были представлены более одного раза на выставках
SELECT DISTINCT Author.*
FROM Author
         JOIN Painting ON Author.ID = Painting.AuthorID
WHERE Painting.ID IN (SELECT PaintingID
                      FROM Exhibition_Painting
                      GROUP BY PaintingID
                      HAVING COUNT(*) > 1);

-- 3) Общее количество скульптур на каждой выставке, а также их рейтинг
SELECT ExhibitionID,
       SculptureCount,
       RANK() OVER (ORDER BY SculptureCount DESC) AS sculpture_rank
FROM (SELECT ExhibitionID, COUNT(*) AS SculptureCount
      FROM Exhibition_Sculpture
      GROUP BY ExhibitionID) AS subquery;

-- 4) Топ авторов по количеству работ
SELECT ID,
       FirstName,
       LastName,
       TotalPaintings,
       RANK() OVER (ORDER BY TotalPaintings DESC) AS author_rank
FROM (SELECT Author.ID, FirstName, LastName, COUNT(*) AS TotalPaintings
      FROM Author
               JOIN Painting ON Author.ID = Painting.AuthorID
      GROUP BY Author.ID) AS subquery;

-- 5) Все картины и скульптуры имеющие букву "О" в названии
SELECT p.Title, COUNT(ep.ExhibitionID) AS Exhibitions
FROM Painting p
         JOIN Exhibition_Painting ep ON p.ID = ep.PaintingID
         JOIN Exhibition e ON ep.ExhibitionID = e.ID
WHERE p.Title LIKE '%о%'
GROUP BY p.ID
UNION
SELECT s.Title, COUNT(es.ExhibitionID) AS Exhibitions
FROM Sculpture s
         JOIN Exhibition_Sculpture es ON s.ID = es.SculptureID
         JOIN Exhibition e ON es.ExhibitionID = e.ID
WHERE s.Title LIKE '%о%'
GROUP BY s.ID;;


-- 6) Статистики по посетителям
SELECT AVG(visit_count)        AS average_visits,
       VARIANCE(visit_count)   AS visit_variance,
       STDDEV_POP(visit_count) AS visit_stddev,
       MIN(visit_count)        AS min_visits,
       MAX(visit_count)        AS max_visits
FROM (SELECT VisitorID, COUNT(*) AS visit_count
      FROM Exhibition_Visitor
      GROUP BY VisitorID) AS visitor_stats;

-- 7) Картины показанные с апреля по июнь 2024
SELECT p.*
FROM Painting p
         JOIN Exhibition_Painting ep ON p.ID = ep.PaintingID
         JOIN Exhibition e ON ep.ExhibitionID = e.ID
WHERE e.StartDate >= '2024-04-01'
  AND e.EndDate <= '2024-07-31';

-- 8) Все экспонаты представленные с января по сентябрь 2024
SELECT s.title,
       s.year,
       concat(a.firstname, ' ', a.lastname) as Author,
       'Скультура'                          as type
FROM Sculpture s
         JOIN Exhibition_Sculpture es ON s.ID = es.SculptureID
         JOIN Exhibition e ON es.ExhibitionID = e.ID
         JOIN author a ON s.authorid = a.id
WHERE e.StartDate >= '2024-01-01'
  AND e.EndDate <= '2024-09-30'

UNION

SELECT p.title,
       p.year,
       concat(a.firstname, ' ', a.lastname) as Author,
       'Картина'                            as type
FROM Painting p
         JOIN Exhibition_Painting ep ON p.ID = ep.PaintingID
         JOIN Exhibition e ON ep.ExhibitionID = e.ID
         JOIN author a on p.authorid = a.id
WHERE e.StartDate >= '2024-01-01'
  AND e.EndDate <= '2024-09-30';

-- 9) Среднее количество авторов на выставках
SELECT AVG(author_count) AS average_authors_per_exhibition
FROM (SELECT COUNT(DISTINCT AuthorID) AS author_count
      FROM (SELECT ExhibitionID, AuthorID
            FROM Exhibition_Painting
                     JOIN Painting ON Exhibition_Painting.PaintingID = Painting.ID
            UNION ALL
            SELECT ExhibitionID, AuthorID
            FROM Exhibition_Sculpture
                     JOIN Sculpture ON Exhibition_Sculpture.SculptureID = Sculpture.ID) AS subquery
      GROUP BY ExhibitionID) AS exhibition_stats;

-- 10) Количество посетителей на выставках
SELECT ExhibitionID, AVG(visitors) AS visitors_per_exhibition
FROM (SELECT ExhibitionID, COUNT(*) AS visitors
      FROM Exhibition_Visitor
      GROUP BY ExhibitionID) AS subquery
GROUP BY ExhibitionID;


