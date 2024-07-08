create procedure dbo.InsertNewDate as

begin
    set nocount on;

    declare @NewDate date;

    -- Calculate new date.
    set @NewDate = dateadd(day, 1, (select max(Date_Key) from ecomm));

    -- Logic check to make sure @NewDate does not exceed the current date.
    if @NewDate <= getdate()
    begin   
        -- Insert new date into dailydates table.
        insert into dailydates (
            Date_Key,
            Exact_Date,
            Year,
            Month,
            Month_Name,
            Quarter,
            Quarter_Name,
            Day_of_Month,
            Day_of_Week,
            Day_of_Week_Name,
            IsWeekend,
            IsHoliday
        )
        select
            @NewDate as Date_Key,
            convert(varchar, @NewDate, 112) as Exact_Date,
            Year,
            Month,
            Month_Name,
            Quarter,
            Quarter_Name,
            Day_of_Month,
            Day_of_Week,
            Day_of_Week_Name,
            IsWeekend,
            IsHoliday
    end;
end;
go