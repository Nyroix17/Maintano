unit dlg_formulaire3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls, Spin, Unit1;

type

  { TDlgFormulaire3 }

  TDlgFormulaire3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    DataSource1: TDataSource;
    description: TMemo;
    Label4: TLabel;
    Label7: TLabel;
    duree: TEdit;
    nom: TEdit;
    Label3: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel9: TPanel;
    SQLQuery1: TSQLQuery;
  private

  public

  end;

var
  DlgFormulaire3: TDlgFormulaire3;

implementation

{$R *.lfm}

end.

