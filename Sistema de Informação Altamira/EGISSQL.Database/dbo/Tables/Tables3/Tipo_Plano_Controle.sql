CREATE TABLE [dbo].[Tipo_Plano_Controle] (
    [cd_tipo_plano_controle] INT          NOT NULL,
    [nm_tipo_plano_controle] VARCHAR (40) NULL,
    [sg_tipo_plano_controle] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Plano_Controle] PRIMARY KEY CLUSTERED ([cd_tipo_plano_controle] ASC) WITH (FILLFACTOR = 90)
);

