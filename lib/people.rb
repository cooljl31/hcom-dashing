require 'spreadsheet'

OPS_PRIMARY = 1
OPS_SECONDARY = 2
RELEASE_PRIMARY = 3
RELEASE_SECONDARY = 4


class People

  @@open_book = Spreadsheet.open('TeamRota.xls')

  def find_person(date, column)
    row_index = @@open_book.worksheet(0).last_row_index

    for b in 1..row_index

      row = @@open_book.worksheet(0).row(b);
      if row[0] == date
        return row[column]
      end

    end

  end

end