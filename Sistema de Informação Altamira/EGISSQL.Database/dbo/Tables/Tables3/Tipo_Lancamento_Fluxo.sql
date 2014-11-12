CREATE TABLE [dbo].[Tipo_Lancamento_Fluxo] (
    [cd_tipo_lancamento_fluxo] INT          NOT NULL,
    [nm_tipo_lancamento_fluxo] VARCHAR (40) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_lancamento_fluxo] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Lancamento_Fluxo] PRIMARY KEY CLUSTERED ([cd_tipo_lancamento_fluxo] ASC) WITH (FILLFACTOR = 90)
);

