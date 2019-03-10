unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

  // Делаем матрицу и её размерность глобальными переменными
  // чтобы они были видны во всех функциях -
  // обработчиков нажатия кнопок
  a: Ar2;       // матрица
  n,m : integer; // число строк и столбцов

implementation

{$R *.lfm}

{ TForm1 }

{Нажали 'Закрыть'}
procedure TForm1.Button1Click(Sender: TObject);
begin
  close;
end;

{Нажали 'Создать матрицу'}
procedure TForm1.Button2Click(Sender: TObject);
var x, y: integer; // размеры одной ячейки
    el_str: string; // строковое представление элемента МАТРИЦЫ
    i, j: integer; // для обхода матрицы
begin
  // Получаем размерность матрицы от пользователя
  // InputBox возвращает строку, но ГЛОБАЛЬНЫЕ переменные n и m типа integer
  // поэтому преобразуем возвращаем значение в целое число при помощи StrToInt
  n := StrToInt(InputBox('Ввод числа', 'Сколько строк?', '5'));
  m := StrToInt(InputBox('Ввод числа', 'Сколько столбцов?', '5'));

  // Теперь так как УЖЕ ЕСТЬ число строк и столбцов
  // Заполняем матрицу
  CreateAr2(a, n, m);

  {выводим матрицу в StringGrid1 - исходная матрица}
  // Сначалао надо очистить StrtingGrid1 и StringGrid2
  // - вдруг там осталась старая матрица
  // это делать не обязательно
  StringGrid1.Clean;
  StringGrid2.Clean;

  // Пускай таблицы будет одинаковыми - так легче будет отображать елементы
  // Из первой таблицы во второй

  StringGrid1.RowCount := n;  // Число столбцов
  StringGrid1.ColCount := m; // Количестов строк  ИСХОДНОЙ ТАБЛИЦЫ

  StringGrid2.RowCount := n;  // Число столбцов
  StringGrid2.ColCount := m; // Количестов строк  РЕЗУЛЬТИРУЮЩЕЙ ТАБЛИЦЫ

  // Чтобы обращаться к атрибутам StringGrid1 без точки
  // Например раньше надо было писать
  // 'StringGrid1.ColCount' , теперь же достаточно просто 'ColCount'
  with StringGrid1 do
  begin

    {Устанавливаем одинаковый размер для всех ячеек}
    // Пусть вся таблица будет шириной 330, а высотой 250 пикселей
    // то есть таблица 330 x 250
    // width и height - это свойства StringGrid1
    // Если бы не with пришлось бы писать StringGrid1.width например

    // Устанавливаем общие размеры ИСХОДНОЙ таблицы
    width := 330;
    height := 250;

    // у РЕЗУЛЬТИРУЮЩЕЙ такие же
    // для StringGrid2 - нужно указывать полное имя
    StringGrid2.Width:= 330;
    StringGrid2.Height:= 250;

    // Здесь стоит отметить, что мы в обоих таблицах
    // StringGrid1 и StringGrid2 через инспектор объектов
    // Изменили свойство ScrollBars - поставили ssNone
    // То есть полосы прокрутки просто никогда не будут появляться

    // Тогда ширина ОДНОЙ ЯЧЕЙКИ
    x := width div ColCount; // ширина всей таблицы делить на число столбцов
    // высота ОДНОЙ ЯЧЕЙКИ
    y := height div RowCount; // высота всей таблицы делить на число строк

    // Задаём размер каждого столбца
    for j:= 0 to ColCount -1 do
    begin
      // Исходная
      ColWidths[j] := x;   // для каждого столбца одна и та же ширина
      // Результирующая
      StringGrid2.ColWidths[j] := x;
    end;
    // Задаём размер каждой строки
    for i:= 0 to RowCount -1 do
    begin
      // Исходная
      RowHeights[i] := y;   // для каждой строки одна и та же высота
      // Результирующая
      StringGrid2.RowHeights[i] := y;
    end;

    // Теперь заполняем таблицу, элементами из матрицы
    // StringGrid2 заполнять НЕ НАДО
    for i:=0 to n-1 do
      for j:=0 to m-1 do
      begin
        // Столбцы и строки у ТАБЛИЦЫ нумеруются с нуля,
        // а в матрице с еденицы
        // поэтому обходим с 0 в циклах
        // и обращаемся к элементам МАТРИЦЫ так a[i+1, j+1]
        // Преобразуем число - елемент матрицы в СТРОКУ
        // Ячейки ТАБЛИЦЫ - это строки
        str(a[i+1, j+1], el_str);
        // Еслибы не with приходилось бы обращаться Memo1.Cells
        // Cells - по сути та же матрица - только нашей таблицы output
        // И строки и столбцы у неё нумеруются с 0 - ЗАПОМНИТЕ
        // Также ВАЖНО помнить, что если обращаться к элементу МАТРИЦЫ
        // То мы пишем сначала номер строки потом столбца : a[i,j](если i,j > 1 конешн)
        // Но в Cells нужно СНАЧАЛА передавать номер СТОЛБЦА, и уже ПОТОМ номер СТРОКИ
        // То есть Cells[j,i] - НЕ опечатка
        Cells[j,i] := el_str;
      end;
end;


end;

{Нажали 'Обработка'}
procedure TForm1.Button3Click(Sender: TObject);
var i, j: integer;
    el_str: integer; // строковое представление элемента матрицы
    ave: real; // Среднее арифметическое одной строки матрицы
    ave_str: string; // СТРОКОВОЕ представление среднего арифметического
    k: integer; // число которое вводит пользователь (Среднее должно быть БОЛЬШЕ него)
    c: integer; // Счётчик добавленный строк в StringGrid2
begin

  // Считываем ИСХОДНУЮ матрицу из StringGrid1
  // На тот случай если что-то поменяли в таблице
  // заметим, что нельзя поменять число строк и столбцов в существующей таблице
  // То есть 'n' и 'm' матрицы остаются неизменными
  // от нуля т.к. столбцы и строки в SringGrid нумеруются с нуля
  for i := 0 to n -1 do
    for j:= 0 to m -1 do
    begin
      // в таблице StringGrid элементы хранятся в виде массива строк
      // Не забываем что для Cells нужно
      // СНАЧАЛА передавать номер СТОЛБЦА, и уже ПОТОМ номер СТРОКИ
      // Так как ячейка таблицы - ЭТО СТРОКА, а элемент матрицы - ЧИСЛО
      // то строку нужно привести к целому числу
      //a[i+1, j+1] - т.к. в матрице НАПРОТИВ строки и столбцы Нумеруются с 1
      a[i+1, j+1]:= StrToInt(StringGrid1.Cells[j,i]);
    end;

  {Добавляем столбик со Средними арифметическими числами каждой строки в Memo1}
  with StringGrid1 do
  begin
    // Добавляем столбец для ПЕРВОЙ таблицы - StringGrid1
    // Опять заметьте внутри with необязательно писать StringGrid1.ColCount
    ColCount := ColCount + 1;

    // Задаём размер этого столбца
    // Тк в StringGrid столбцы нумеруются с 0, то индекс последнего столбца
    // ColCount-1 - как раз наш добавленный столбец
    ColWidths[ColCount-1] := 50;

    // Тогда надо увеличить и ширину всей таблицы
    Width := Width + 50;

    // обходим строки матрицы
    for i:=1 to n do
    begin
      // Находим Среднее арифметическое чисел в i-ой строке
      ave := FindAverage(a[i], m);
      // В StringGrid можно записать только строки
      // 5 - скоько полей выделяется на всё число
      // 2 - сколько значащих цифр после запятой
      str(ave:5:2, ave_str);
      // Записываем СРЕДНЕЕ каждой строки таблицы в специально подготовленный нами
      // столбец - последний столбец
      // ColCount-1 - индекс последнего столбца
      // i-1 - так как цикл перебирает с 1, а в StringGrid нумератция с нуля
      Cells[ColCount-1,i-1] := ave_str;
    end;

    // Получаем число, от польователя, чтобы понять
    // какие строки печатать в StringGrid2
    // Среднее Арифметическое этих строк БОЛЬШЕ этого числа
    k := StrToInt(InputBox('Обработка', 'Введите число', '50'));

    // Делаем это именно после добавления столбца СРЕДНИХ в StringGrid1
    // Чтобы можно было посмотреть СРЕДНЕЕ каждой строки и подобрать число K
    // Хотя можно было и вначале получить это число
    // И проверять строки матрицы в цикле выше
    // Но так более кросиво со стороны интерфейса смотрица

    // теперь добавляем строки в StringGrid2
    for i:=1 to n do
    begin
      // Получаем Среднее для i-ой строки
      // Здесь лучше не вызывать ещё раз FindAverage
      // Мы же сохранили СРЕДНЕЕ для каждой строки в отдельный столбец
      // Вот и Считываем из этого столбца СРЕДНЕЕ
      // Но нужно привести их к целому типу
      ave := StrToFloat(Cells[ColCount-1, i-1]);
      // Если СРЕДНЕЕ больше K - то это строка должна быть в Memo2
      if (ave > k) then
        begin
          c := c+1; // увеличиваем счётчик добавляемых строк
          // Выводим с-ую строку в StringGrid2
          for j:=1 to m do
            // Здесь Cells - относится к StringGrid1 из-за with
            // Для StringGrid2 нужно указывать полное имя через точку
            StringGrid2.Cells[j-1, c-1] := Cells[j-1, i-1];
         end;
     end;

   end;

end;

{Нажали 'Очистить'}
procedure TForm1.Button4Click(Sender: TObject);
begin
  // Нужно очистить две таблицы
  // реализация очистки есть внутри этих объектов
  StringGrid1.Clean;
  StringGrid2.Clean;
end;

end.

