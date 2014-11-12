CREATE TABLE [dbo].[Controle_Deteccao] (
    [cd_controle_deteccao] INT          NOT NULL,
    [nm_controle_deteccao] VARCHAR (50) NULL,
    [ds_controle_deteccao] TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Controle_Deteccao] PRIMARY KEY CLUSTERED ([cd_controle_deteccao] ASC) WITH (FILLFACTOR = 90)
);

