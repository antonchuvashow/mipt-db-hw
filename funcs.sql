-- функция для получения информации о работах определенного автора
CREATE OR REPLACE FUNCTION GetAuthorWorks(p_authorID INT)
    RETURNS TABLE
            (
                p_ID    INT,
                p_Title VARCHAR(255),
                p_Year  INT,
                p_Type  TEXT -- Поле, указывающее тип работы (картина или скульптура)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT ID,
               Title,
               Year,
               'Painting' AS Type
        FROM Painting
        WHERE AuthorID = p_authorID
        UNION ALL
        SELECT ID,
               Title,
               Year,
               'Sculpture' AS Type
        FROM Sculpture
        WHERE AuthorID = p_authorID;
END;
$$;

-- функция для получения выставок, которые идут сегодня
CREATE OR REPLACE FUNCTION GetExhibitionsToday()
    RETURNS TABLE
            (
                p_ID          INT,
                p_Name        VARCHAR(255),
                p_Description TEXT,
                p_StartDate   DATE,
                p_EndDate     DATE
            )
    LANGUAGE plpgsql
AS
$$
    BEGIN RETURN QUERY
SELECT *
FROM Exhibition
WHERE StartDate <= CURRENT_DATE
  AND EndDate >= CURRENT_DATE;
END;
$$;

-- Процедура для добавления нового произведения
CREATE OR REPLACE PROCEDURE AddArtwork(
    IN p_id INT,
    IN p_title VARCHAR(255),
    IN p_year INT,
    IN p_type VARCHAR(50), -- Тип произведения (Painting или Sculpture)
    IN p_technique VARCHAR(255), -- Для картины (можно NULL для скульптуры)
    IN p_material VARCHAR(255), -- Для скульптуры (можно NULL для картины)
    IN p_description TEXT,
    IN p_authorID INT
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    artworkID INT;
BEGIN
    IF p_type = 'Painting' THEN
        INSERT INTO Painting (ID, Title, Year, Technique, Description, AuthorID)
        VALUES (p_id, p_title, p_year, p_technique, p_description, p_authorID)
        RETURNING ID INTO artworkID;
    ELSIF p_type = 'Sculpture' THEN
        INSERT INTO Sculpture (ID, Title, Year, Material, Description, AuthorID)
        VALUES (p_id, p_title, p_year, p_material, p_description, p_authorID)
        RETURNING ID INTO artworkID;
    ELSE
        RAISE EXCEPTION 'Unknown artwork type: %', p_type;
    END IF;

    RETURN;
END;
$$;