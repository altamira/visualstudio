CREATE TABLE [dbo].[Concorrente] (
    [cd_concorrente]          INT           NOT NULL,
    [nm_concorrente]          VARCHAR (30)  NOT NULL,
    [sg_concorrente]          CHAR (10)     NOT NULL,
    [cd_usuario]              INT           NOT NULL,
    [dt_usuario]              DATETIME      NOT NULL,
    [cd_tipo_concorrente]     INT           NULL,
    [ds_concorrente]          TEXT          NULL,
    [nm_site_concorrente]     VARCHAR (100) NULL,
    [nm_logotipo_concorrente] VARCHAR (100) NULL,
    CONSTRAINT [PK_Concorrente] PRIMARY KEY CLUSTERED ([cd_concorrente] ASC) WITH (FILLFACTOR = 90)
);

