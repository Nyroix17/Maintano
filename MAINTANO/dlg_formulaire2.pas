unit dlg_formulaire2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls, Spin, Unit1;

type

  { TDlgFormulaire2 }

  TDlgFormulaire2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BtnPhoto: TButton;
    DataSource1: TDataSource;
    Label8: TLabel;
    Label9: TLabel;
    marque: TEdit;
    kilometrage: TFloatSpinEdit;
    Immat: TEdit;
    Poids: TEdit;
    Label7: TLabel;
    couleur: TEdit;
    modele: TEdit;
    OpenDialog1: TOpenDialog;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel9: TPanel;
    Photo: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    SQLQuery1: TSQLQuery;
    procedure BtnPhotoClick(Sender: TObject);
  private

  public

  end;

var
   DlgFormulaire2: TDlgFormulaire2;

implementation

{$R *.lfm}

{ TDlgFormulaire2 }

procedure TDlgFormulaire2.BtnPhotoClick(Sender: TObject);
begin
  OpenDialog1.Filter :=
    'Images JPG|*.jpg;*.jpeg|Toutes images|*.png;*.bmp;*.jpg';

  if OpenDialog1.Execute then
    Photo.Text := OpenDialog1.FileName;
end;

end.

