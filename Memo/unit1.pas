unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
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

{Процедура добавления ОДНОЙ строки чисел в Memo(Печатаем одномерный массив)}
// row - одномерный массив -СТРОКА МАТРИЦЫ(Поэтому Ar1, а не Ar2)
// m - число столбцов
// aMemo - Объект мемо куда записываем строку матрицы(var т.к. изменяем его)
procedure PrintAr1(row: Ar1; m: integer; var aMemo: TMemo);
var
   // строковое представление одного числа
   el_str: string;
   // Строкое представление одномерного массива row
   // то есть это сумма строковых представлений каждого элемента(el_str)
   // одномерного массива 'row'
   row_str: string;
   j: integer; // для перебора столбцов
begin
  row_str:='';
  for j:=1 to m do
  begin
    // преобразуем ЕЛЕМЕНТ СТРОКИ(одномерного массива) в строку
    // число 4 - так же как и в writeln - ширина поля под число
    // чтобы не замарачиваться с пробелами при выводе
    str(row[j]:4, el_str);
    // по одному элементы Одномерного массива 'row' собираем в одну строку
    row_str := row_str + el_str;
  end;
  // собрали одну строку, теперь добавляем её в Memo
  aMemo.Append(row_str);
end;

{Вывод МАТРИЦЫ в Memo}
// a - наша матрица - двухмерный массив(поэтому тип Ar2, а не A1)
// n - число строк
// m - число столбцов
// 'var aMemo:TMemo' так как мы будем изменять объект Memo - записывать в него
// Хотя это не обязательно, работает и без, тупо для приличия делаем так
procedure PrintAr2(a: Ar2; n: integer; m: integer; var aMemo: TMemo);
var
  i: integer;
begin
  // перед записью чего-то в Memo очищаем его
  aMemo.Clear;

  // Оюходим все строки
  for i:=1 to n do
      // И печатаем каждую строку в переданный объект mem типа TMemo
      PrintAr1(a[i], m, aMemo);
end;


// Понадобиться если Преподаватель захочет изменить матрицу в Memo1
// и чтобы эти изменения были отображены в работе программы
// например изменит число в строке - тогда среднее арифметическое строки
// должно поменяться

// Необязательно - по прихоти препода
// Если что раскомментируй - убери вначале '{' и в конце '}'
// Дальше смотри {Нажали 'Обработка'}

{

{Считываем матрицу из Memo}
// 'var' чтобы изменить переменные передавааемые в функцию
// mem: TMemo без var т.к. мы только считываем оттуда
procedure InputAr2(var a: Ar2; var n: integer; var m: integer; mem:TMemo);
var i, j: integer;
    c: integer; // номер столбца элемента
    el_str: string; // строковое представление елемента матрицы

begin

  // Перебираем строки из Memo
  for i:=0 to mem.Lines.Count-1 do
  begin

    j :=1;  // Счётчик СИМВОЛОВ в строке
    c := 0; // Счётчик ЭЛЕМЕНТОВ - найденных ЧИСЕЛ
    // Перебираем i-ую строку посимвольно
    while (j <= length(mem.Lines[i])) do
    begin
      // собираем из символов число
      el_str := ''; // cтрока цифр - элемент матрицы в виде строки
      while ((j <= length(mem.Lines[i])) and (mem.Lines[i][j] in ['0' .. '9'])) do
      begin
         el_str := el_str + mem.Lines[i][j];
         j:= j +1;
      end;

      // Нужно сделать проверку
      // Вдруг вначале стояли пробелы и мы даже не начали цикл выше
      // то есть mem.Lines[i][j] in ['0' .. '9'] - ЛОЖЬ

      // если строковое представление элемента - НЕ пустая строка
      if (not (el_str = '')) then
      begin
        // Мы смогли собрать число
        // Увеличиваем счётчик элементов в одной строке
        c:= c + 1;
        // И добавляем число в матрицу
        // i+1 - тк строки в Memo нумеруются с 0, а в матрице с 1
        a[i+1, c] := StrToInt(el_str); // нужно привести к целому типу

        // По поводу счётчика елементов 'с' - счётчика чисел в строке
        // мы не можем перебрать элементы из строки в цикле for
        // так как не известно их количество
        // так же мы не можем перебрать элемнты считывая их по одному
        // как в readln т.к. мы имеем только строки и мы должны преобразовать
        // последовательность символов в ЦЕЛОЧИСЛЕННЫЕ элементы матрицы
        // Счётчик элементов 'c' в строке будет увеличиваться каждый раз,
        // когда мы находим(собираем из символом) число в строке
        // и  он будет обнуляться при переходе на новую строку
      end;

      // если мы здесь то дальше какой-то символ - НЕ цифра

      // Перебираем строку до тех пор пока не попадём не цыфру
      // Нам нужны только цыфры, а остальные символы просто пропускаем
      while ((j <= length(mem.Lines[i])) and not (mem.Lines[i][j] in ['0' .. '9'])) do
        j := j + 1;
    end;
  end;
  // Нужно также задать РАЗМЕРНОСТЬ полученной матрицы
  n:= mem.Lines.Count; // число строк = число строк в Memo
  // Число столбцов равно счётчику элементов в одной строке
  // Прричом заметь, что после завершения цикла с - не обнуляется
  // И равен как раз найденному числу элементов в строке
  m:= c;
end;

}

{Нажали 'Закрыть'}
procedure TForm1.Button1Click(Sender: TObject);
begin
  close;
end;

{Нажали 'Создать матрицу'}
procedure TForm1.Button2Click(Sender: TObject);
begin
  // Получаем размерность матрицы от пользователя
  // InputBox возвращает строку, но ГЛОБАЛЬНЫЕ переменные n и m типа integer
  // поэтому преобразуем возвращаем значение в целое число при помощи StrToInt
  n := StrToInt(InputBox('Ввод числа', 'Сколько строк?', '5'));
  m := StrToInt(InputBox('Ввод числа', 'Сколько столбцов?', '5'));

  // Теперь так как УЖЕ ЕСТЬ число строк и столбцов
  // Заполняем матрицу
  CreateAr2(a, n, m);

  // выводим матрицу в Memo1 - исходная матрица
  PrintAr2(a, n, m, Memo1);

end;

{Нажали 'Обработка'}
procedure TForm1.Button3Click(Sender: TObject);
var i: integer;
    ave: real; // Среднее арифметическое одной строки матрицы
    ave_str: string; // СТРОКОВОЕ представление среднего арифметического
    k: integer; // число которое вводит пользователь (Среднее должно быть БОЛЬШЕ него)
begin

  // Считываем ИСХОДНУЮ матрицу из Memo1
  // Необязательно, смотри определение процедуры, для нужного функционала
  // не забудь раскомментировать здесь тоже
  // InputAr2(a, n, m, Memo1);

  // Переменные a, n, m - глобальне переменны, которые видны во всех процедурах
  // их значения должны быть УЖЕ ЗАДАНЫ при нажатии кнопки {Создать матрицу}

  {Добавляем столбик со Средними арифметическими числами каждой строки в Memo1}
  // обходим строки матрицы
  for i:=1 to n do
  begin
    // Находим Среднее арифметическое чисел в i-ой строке
    ave := FindAverage(a[i], m);
    // В Мемо можно записать только строки
    // FindAverage - возвращет вещественно число
    // Нужно преобразовать это число к типу строк при помощи процедуры str
    // ave:10:2 - числа после функции - тоже самое, что и
    // при выводе при помощи writeln
    // 10 - сколько отводится места на всё число
    // 2 - количество значащих чиел после запятой
    // например writeln(float_number:10:2);
    // float_number в нашем случае - то,
    // что вернёт вызов функции FindAverage(a[i], m) - значение переменной 'ave'
    str(ave:10:2, ave_str);
    // добавляем к каждой строке в Memo справа - это число
    Memo1.Lines[i-1] := Memo1.Lines[i-1] + ave_str;
  end;


   // Получаем число, от польователя, чтобы понять
   // какие строки печатать в Memo2
   // Среднее Арифметическое этих строк БОЛЬШЕ этого числа
   k := StrToInt(InputBox('Обработка', 'Введите число', '50'));

   // Делаем это именно после добавления столбца СРЕДНИХ в Memo1
   // Чтобы можно было посмотреть СРЕДНЕЕ каждой строки и подобрать число K
   // Хотя можно было и вначале получить это число
   // И проверять строки матрицы в цикле выше
   // НИЖЕ же мы повторно вызываем FindAverage,
   // но ЗАТО можем видеть СРЕДНЕЕ строки

   // теперь добавляем строки в Memo2
   for i:=1 to n do
   begin
     // Получаем Среднее для i-ой строки
     ave := FindAverage(a[i], m);
     // Если СРЕДНЕЕ больше K - то это строка должна быть в Memo2
     if (ave > k) then
        PrintAr1(a[i], m, Memo2);
   end;

end;

{Нажали 'Очистить'}
procedure TForm1.Button4Click(Sender: TObject);
begin
  // Нужно очистить два текстовых поля
  // реализация очистки есть внутри этих объектов
  Memo1.Clear;
  Memo2.Clear;
end;

end.

