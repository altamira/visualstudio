CREATE TABLE [dbo].[Laudo_Aplicacao] (
    [cd_laudo]           INT      NOT NULL,
    [cd_laudo_aplicacao] INT      NOT NULL,
    [cd_tipo_aplicacao]  INT      NULL,
    [nm_laudo_aplicacao] TEXT     NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Laudo_Aplicacao] PRIMARY KEY CLUSTERED ([cd_laudo] ASC, [cd_laudo_aplicacao] ASC) WITH (FILLFACTOR = 90)
);

