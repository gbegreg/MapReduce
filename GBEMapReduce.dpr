program GBEMapReduce;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form2},
  GBEArray in 'GBEArray.pas',
  uPersonne in 'uPersonne.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
