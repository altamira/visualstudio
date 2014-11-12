CREATE TABLE [dbo].[Modalidade] (
    [cd_modalidade]          INT           NOT NULL,
    [nm_modalidade]          VARCHAR (40)  NULL,
    [sg_modalidade]          CHAR (10)     NULL,
    [ic_ativa_modalidade]    CHAR (1)      NULL,
    [ds_modalidade]          TEXT          NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [ds_tecnica_modalidade]  TEXT          NULL,
    [nm_logotipo_modalidade] VARCHAR (100) NULL,
    CONSTRAINT [PK_Modalidade] PRIMARY KEY CLUSTERED ([cd_modalidade] ASC) WITH (FILLFACTOR = 90)
);

