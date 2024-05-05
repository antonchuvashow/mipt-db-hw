-- Представление для списка всех авторов и их работ
CREATE VIEW AuthorWorks AS
SELECT a.*, p.ID AS PaintingID, p.Title AS PaintingTitle, s.ID AS SculptureID, s.Title AS SculptureTitle
FROM Author a
LEFT JOIN Painting p ON a.ID = p.AuthorID
LEFT JOIN Sculpture s ON a.ID = s.AuthorID;

-- Представление для списка всех выставок с соответствующими работами
CREATE VIEW ExhibitionArtworks AS
SELECT e.*, p.ID AS PaintingID, p.Title AS PaintingTitle, s.ID AS SculptureID, s.Title AS SculptureTitle
FROM Exhibition e
LEFT JOIN Exhibition_Painting ep ON e.ID = ep.ExhibitionID
LEFT JOIN Painting p ON ep.PaintingID = p.ID
LEFT JOIN Exhibition_Sculpture es ON e.ID = es.ExhibitionID
LEFT JOIN Sculpture s ON es.SculptureID = s.ID;

-- Представление для списка всех выставок с количеством посетителей
CREATE VIEW ExhibitionVisitors AS
SELECT e.*, COUNT(ev.VisitorID) AS VisitorCount
FROM Exhibition e
LEFT JOIN Exhibition_Visitor ev ON e.ID = ev.ExhibitionID
GROUP BY e.ID;
