unit dlg_formulaire4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, DBGrids, StdCtrls, FPReadJPEG, FPWriteJPEG, LCLIntf;

type

  { TDlgFormulaire4 }

  TDlgFormulaire4 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    SQLQueryAction: TSQLQuery;
    Statut: TComboBox;
    Suprimer: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    effectuer: TMemo;
    cours: TMemo;
    termine: TMemo;
    Image1: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    NumeroEntretien: TEdit;
    Immat: TEdit;
    DateArriver: TEdit;
    DateDepart: TEdit;
    DateCharge: TEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel9: TPanel;
    Evaluation: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    description: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    SQLQuery1: TSQLQuery;
    procedure BitBtn2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SuprimerClick(Sender: TObject);
  private
    function VerifierDates: Boolean;
    function BuildChemin(const NomFichier: string): string;
  public
        NomPhoto : String;
        procedure ChargerImage(const NomFichier: string);
        procedure ChargerTaches;
  end;

var
  DlgFormulaire4: TDlgFormulaire4;

implementation

{$R *.lfm}

procedure TDlgFormulaire4.SuprimerClick(Sender: TObject);
begin
  if MessageDlg(
    'Supprimer cet entretien ?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) = mrYes then
  begin
    ModalResult := mrAbort;
  end;
end;

procedure TDlgFormulaire4.Button2Click(Sender: TObject);
var
    F : TextFile;
    NomFichier : String;
    PhotoPath  : String;
begin
    NomFichier :=
      'FicheVehicule' + PathDelim +
      'entretien_' +
      NumeroEntretien.Text +
      '.html';

    // chemin image
    PhotoPath := BuildChemin(
      ExtractFileName(Image1.Hint)
    );

    AssignFile(F, NomFichier);
    Rewrite(F);

    Writeln(F, '<!DOCTYPE html>');
    Writeln(F, '<html lang="fr">');

    Writeln(F, '<head>');
    Writeln(F, '<meta charset="UTF-8">');
    Writeln(F, '<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    Writeln(F, '<title>Fiche Véhicule - Document</title>');

    // =========================
    // CSS
    // =========================

    Writeln(F, '<style>');

    Writeln(F, 'body {');
    Writeln(F, 'font-family: Segoe UI, Tahoma, Geneva, Verdana, sans-serif;');
    Writeln(F, 'background-color: #ffffff;');
    Writeln(F, 'color: #333333;');
    Writeln(F, 'margin: 0;');
    Writeln(F, 'padding: 40px;');
    Writeln(F, 'display: flex;');
    Writeln(F, 'justify-content: center;');
    Writeln(F, '}');

    Writeln(F, '.fiche-container {');
    Writeln(F, 'width: 100%;');
    Writeln(F, 'max-width: 900px;');
    Writeln(F, 'border: 2px solid #2c3e50;');
    Writeln(F, 'padding: 30px;');
    Writeln(F, 'border-radius: 8px;');
    Writeln(F, 'box-shadow: 0 0 10px rgba(0,0,0,0.1);');
    Writeln(F, '}');

    Writeln(F, '.fiche-header {');
    Writeln(F, 'text-align: center;');
    Writeln(F, 'border-bottom: 3px solid #2c3e50;');
    Writeln(F, 'margin-bottom: 30px;');
    Writeln(F, 'padding-bottom: 10px;');
    Writeln(F, '}');

    Writeln(F, '.fiche-header h1 {');
    Writeln(F, 'margin: 0;');
    Writeln(F, 'color: #2c3e50;');
    Writeln(F, 'text-transform: uppercase;');
    Writeln(F, 'letter-spacing: 2px;');
    Writeln(F, '}');

    Writeln(F, '.content-grid {');
    Writeln(F, 'display: grid;');
    Writeln(F, 'grid-template-columns: 1fr 1fr;');
    Writeln(F, 'gap: 40px;');
    Writeln(F, '}');

    Writeln(F, '.section-title {');
    Writeln(F, 'font-size: 1.2rem;');
    Writeln(F, 'color: #2980b9;');
    Writeln(F, 'border-bottom: 1px solid #bdc3c7;');
    Writeln(F, 'padding-bottom: 5px;');
    Writeln(F, 'margin-bottom: 20px;');
    Writeln(F, 'text-transform: uppercase;');
    Writeln(F, '}');

    Writeln(F, '.photo-container img {');
    Writeln(F, 'width: 100%;');
    Writeln(F, 'height: 250px;');
    Writeln(F, 'object-fit: contain;');
    Writeln(F, 'border: 1px solid #ccc;');
    Writeln(F, '}');

    Writeln(F, '.info-row {');
    Writeln(F, 'display: flex;');
    Writeln(F, 'margin-bottom: 12px;');
    Writeln(F, 'border-bottom: 1px solid #f0f0f0;');
    Writeln(F, 'padding-bottom: 5px;');
    Writeln(F, '}');

    Writeln(F, '.info-label {');
    Writeln(F, 'font-weight: bold;');
    Writeln(F, 'width: 140px;');
    Writeln(F, 'color: #34495e;');
    Writeln(F, '}');

    Writeln(F, '.info-value {');
    Writeln(F, 'flex: 1;');
    Writeln(F, 'color: #2c3e50;');
    Writeln(F, '}');

    Writeln(F, '.task-box {');
    Writeln(F, 'margin-bottom: 25px;');
    Writeln(F, '}');

    Writeln(F, '.task-label {');
    Writeln(F, 'font-weight: bold;');
    Writeln(F, 'display: block;');
    Writeln(F, 'margin-bottom: 8px;');
    Writeln(F, 'color: #34495e;');
    Writeln(F, 'font-size: 0.95rem;');
    Writeln(F, '}');

    Writeln(F, '.task-content {');
    Writeln(F, 'min-height: 80px;');
    Writeln(F, 'background-color: #fcfcfc;');
    Writeln(F, 'border: 1px solid #ecf0f1;');
    Writeln(F, 'padding: 10px;');
    Writeln(F, 'border-radius: 4px;');
    Writeln(F, '}');

    Writeln(F, '</style>');
    Writeln(F, '</head>');

    // =========================
    // BODY
    // =========================

    Writeln(F, '<body>');
    Writeln(F, '<div class="fiche-container">');

    Writeln(F, '<div class="fiche-header">');
    Writeln(F, '<h1>Fiche d''Intervention Véhicule</h1>');
    Writeln(F, '</div>');

    Writeln(F, '<div class="content-grid">');

    // =========================
    // COLONNE VEHICULE
    // =========================

    Writeln(F, '<div class="info-column">');

    Writeln(F, '<h2 class="section-title">Détails du véhicule</h2>');

    Writeln(F, '<div class="photo-container">');
    Writeln(F,
      '<img src="' +
      BuildChemin(Image1.Hint) +
      '">'
    );
    Writeln(F, '</div>');

    Writeln(F,
      '<div class="info-row"><div class="info-label">Immatriculation :</div><div class="info-value">' +
      Immat.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="info-row"><div class="info-label">Date arrivée :</div><div class="info-value">' +
      DateArriver.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="info-row"><div class="info-label">Date prise en charge :</div><div class="info-value">' +
      DateCharge.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="info-row"><div class="info-label">Date départ :</div><div class="info-value">' +
      DateDepart.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="info-row"><div class="info-label">Statut :</div><div class="info-value">' +
      Statut.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="info-row"><div class="info-label">Evaluation :</div><div class="info-value">' +
      Evaluation.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="info-row"><div class="info-label">Description :</div><div class="info-value">' +
      description.Lines.Text +
      '</div></div>'
    );

    Writeln(F, '</div>');

    // =========================
    // COLONNE TACHES
    // =========================

    Writeln(F, '<div class="tasks-column">');
    Writeln(F, '<h2 class="section-title">Suivi des tâches</h2>');

    Writeln(F,
      '<div class="task-box"><span class="task-label">Tâches à effectuer :</span><div class="task-content">' +
      effectuer.Lines.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="task-box"><span class="task-label">Tâches en cours :</span><div class="task-content">' +
      cours.Lines.Text +
      '</div></div>'
    );

    Writeln(F,
      '<div class="task-box"><span class="task-label">Tâches terminées :</span><div class="task-content">' +
      termine.Lines.Text +
      '</div></div>'
    );

    Writeln(F, '</div>');

    Writeln(F, '</div>');
    Writeln(F, '</div>');
    Writeln(F, '</body>');
    Writeln(F, '</html>');

    CloseFile(F);

    ShowMessage(
      'HTML généré avec succès :' + LineEnding +
      NomFichier
    );
    OpenDocument(NomFichier)
  end;

procedure TDlgFormulaire4.BitBtn2Click(Sender: TObject);
begin
  if VerifierDates then
    ModalResult := mrOK;
end;

function TDlgFormulaire4.BuildChemin(const NomFichier: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'photos' + PathDelim + NomFichier;
end;

procedure TDlgFormulaire4.ChargerImage(const NomFichier: string);
begin
    Image1.Picture.Clear;

    if Trim(NomFichier) = '' then
      Exit;

    Image1.Hint := NomFichier;

    if FileExists(BuildChemin(NomFichier)) then
      Image1.Picture.LoadFromFile(
        BuildChemin(NomFichier)
      );
end;

procedure TDlgFormulaire4.ChargerTaches;
begin
  effectuer.Clear;
  cours.Clear;
  termine.Clear;

  // exemple simple selon le statut

  if Statut.Text = 'En attente' then
  begin
    effectuer.Lines.Add('- Vérification moteur');
    effectuer.Lines.Add('- Vérification pneus');
    effectuer.Lines.Add('- Contrôle freins');
  end;

  if Statut.Text = 'En cours' then
  begin
    cours.Lines.Add('- Vidange en cours');
    cours.Lines.Add('- Diagnostic électronique');
  end;

  if Statut.Text = 'Terminé' then
  begin
    termine.Lines.Add('- Révision terminée');
    termine.Lines.Add('- Véhicule prêt');
  end;
end;

function TDlgFormulaire4.VerifierDates: Boolean;
begin
  Result := False;

  // =========================
  // PRISE EN CHARGE
  // =========================

  if (DateCharge.Text <> '') and
     (StrToDate(DateCharge.Text) <
      StrToDate(DateArriver.Text)) then
  begin
    ShowMessage(
      'La date de prise en charge ne peut pas être avant la date d''arrivée.'
    );

    DateCharge.SetFocus;
    Exit;
  end;

  // =========================
  // DEPART
  // =========================

  if (DateDepart.Text <> '') and
     (StrToDate(DateDepart.Text) <
      StrToDate(DateArriver.Text)) then
  begin
    ShowMessage(
      'La date de départ ne peut pas être avant la date d''arrivée.'
    );

    DateDepart.SetFocus;
    Exit;
  end;

  // =========================
  // DEPART < PRISE EN CHARGE
  // =========================

  if (DateDepart.Text <> '') and
     (DateCharge.Text <> '') and
     (StrToDate(DateDepart.Text) <
      StrToDate(DateCharge.Text)) then
  begin
    ShowMessage(
      'La date de départ ne peut pas être avant la prise en charge.'
    );

    DateDepart.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.

