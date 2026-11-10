program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, Unit1, module1, module2, dlg_formulaire1, module0,
  module3, dlg_formulaire2, dlg_formulaire3, dlg_formulaire4, dlg_formulaire5,
  dlg_formulaire6
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.MainFormOnTaskbar:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDlgFormulaire1, DlgFormulaire1);
  Application.CreateForm(TDlgFormulaire2, DlgFormulaire2);
  Application.CreateForm(TDlgFormulaire3, DlgFormulaire3);
  Application.CreateForm(TDlgFormulaire4, DlgFormulaire4);
  Application.CreateForm(TDlgFormulaire5, DlgFormulaire5);
  Application.CreateForm(TDlgFormulaire6, DlgFormulaire6);
  Application.Run;
end.

