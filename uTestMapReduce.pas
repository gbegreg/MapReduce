unit uTestMapReduce;

interface

uses
  DUnitX.TestFramework, System.SysUtils, RegularExpressions, GBEArray;

type
  [TestFixture]
  TestMapReduce = class
  private
    function convertStringToArrayInt(aString : string):TArray<integer>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('Test 1 MAP OK','1;2;3;53;-2,2;4;6;106;-4')]
    [TestCase('Test 2 MAP OK','32;12;-43;68;89;13;103;23,64;24;-86;136;178;26;206;46')]
    procedure TestMapInteger(aValue, expectedResult : string);
    [Test]
    [TestCase('Test 3 MAP K0 (valeur)','1;2;3;53;-2,2;4;6;106;4')]
    [TestCase('Test 4 MAP K0 (longueur)','1;2;3;53,2;4;6;106;4')]
    procedure TestMapIntegerKO(aValue, expectedResult : string);
    [Test]
    [TestCase('Test 5 REDUCE OK','5;8;3,16')]
    [TestCase('Test 6 REDUCE OK','1;2;3;53;-2,57')]
    procedure TestReduceInteger(aValue, expectedResult : string);
  end;

implementation

uses System.Generics.Collections, System.Generics.Defaults, System.Types;

function TestMapReduce.convertStringToArrayInt(aString: string): TArray<integer>;
begin
  var sep := ';';
  var tabEntree := aString.Split(sep);
  SetLength(result, length(tabEntree));
  for var i := 0 to length(tabEntree)-1 do begin
     result[i] := StrToIntdef(tabEntree[i],0);
  end;
end;

procedure TestMapReduce.Setup;
begin
end;

procedure TestMapReduce.TearDown;
begin
end;

procedure TestMapReduce.TestMapInteger(aValue, expectedResult : string);
begin
  var tabEntreeInt := convertStringToArrayInt(aValue);
  var tabExpectedResultInt := convertStringToArrayInt(expectedResult);

  var resultat := TGBEArray<integer>.Create(tabEntreeInt)
                                    .Map<integer>(function(value: integer): integer begin result := value * 2; end)
                                    .ToArray;

  var isOK := length(resultat) = length(tabExpectedResultInt);

  if isOK then begin
    for var i := 0 to length(resultat)-1 do begin
      isOK := resultat[i] = tabExpectedResultInt[i];
      if not(isOk) then break;
    end;
  end;

  assert.IsTrue(isOK);
end;

procedure TestMapReduce.TestMapIntegerKO(aValue, expectedResult : string);
begin
  var tabEntreeInt := convertStringToArrayInt(aValue);
  var tabExpectedResultInt := convertStringToArrayInt(expectedResult);

  var resultat := TGBEArray<integer>.Create(tabEntreeInt)
                                    .Map<integer>(function(value: integer): integer begin result := value * 2; end)
                                    .ToArray;

  var isOK := length(resultat) = length(tabExpectedResultInt);

  if isOK then begin
    for var i := 0 to length(resultat)-1 do begin
      isOK := resultat[i] = tabExpectedResultInt[i];
      if not(isOk) then break;
    end;
  end;

  assert.IsFalse(isOK);
end;


procedure TestMapReduce.TestReduceInteger(aValue, expectedResult: string);
begin
  var tabEntreeInt := convertStringToArrayInt(aValue);
  var expectedResultInt := strtointdef(expectedResult, -1);

  var resultat := TGBEArray<integer>.Create(tabEntreeInt)
                                    .Reduce<integer>(function(valeurPrec, valeur: integer): integer
                                                     begin
                                                       result := valeurPrec + valeur;
                                                     end, 0);

  var isOK := resultat = expectedResultInt;
  assert.IsTrue(isOk);
end;

initialization
  TDUnitX.RegisterTestFixture(TestMapReduce);

end.
