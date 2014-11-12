CREATE TABLE [dbo].[Codigo_CT] (
    [cd_tabela]  INT           NULL,
    [nm_tabela]  VARCHAR (100) NULL,
    [cd_atual]   INT           NOT NULL,
    [sg_status]  CHAR (1)      NOT NULL,
    [cd_usuario] INT           NULL,
    [dt_usuario] DATETIME      NULL,
    CONSTRAINT [PK_Codigo_CT] PRIMARY KEY CLUSTERED ([cd_atual] ASC, [sg_status] ASC) WITH (FILLFACTOR = 90)
);

