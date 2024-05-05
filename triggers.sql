-- Триггер для проверки ограничения временного интервала выставки
CREATE OR REPLACE FUNCTION validate_exhibition_dates()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NEW.StartDate >= NEW.EndDate THEN
        RAISE EXCEPTION 'Start date must be before end date';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER exhibition_dates_trigger
    BEFORE INSERT OR UPDATE
    ON Exhibition
    FOR EACH ROW
EXECUTE FUNCTION validate_exhibition_dates();

-- Триггер для проверки возраста посетителя
CREATE OR REPLACE FUNCTION check_visitor_age()
    RETURNS TRIGGER
    LANGUAGE plpgsql AS
$$
BEGIN
    IF DATE_PART('year', AGE(NEW.BirthDate)) < 18 THEN
        RAISE EXCEPTION 'Visitor must be at least 18 years old';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER check_visitor_age_trigger
    BEFORE INSERT
    ON Visitor
    FOR EACH ROW
EXECUTE FUNCTION check_visitor_age();

-- Триггер для автоматического добавления выставки в Exhibition_MuseumEmployee
CREATE OR REPLACE FUNCTION add_exhibition_to_employees()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO Exhibition_MuseumEmployee (ExhibitionID, MuseumEmployeeID)
    SELECT NEW.ID, ID
    FROM MuseumEmployee;
    RETURN NEW;
END;
$$;

CREATE TRIGGER add_exhibition_to_employees_trigger
    AFTER INSERT
    ON Exhibition
    FOR EACH ROW
EXECUTE FUNCTION add_exhibition_to_employees();
