CREATE TABLE [dbo].[Acao] (
    [cd_acao]          INT          NOT NULL,
    [nm_acao]          VARCHAR (60) NULL,
    [nm_fantasia_acao] VARCHAR (20) NULL,
    [ds_acao]          TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [cd_tipo_acao]     INT          NULL,
    CONSTRAINT [PK_Acao] PRIMARY KEY CLUSTERED ([cd_acao] ASC) WITH (FILLFACTOR = 90)
);

