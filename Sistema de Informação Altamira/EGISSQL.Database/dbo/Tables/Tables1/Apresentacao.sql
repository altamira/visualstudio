CREATE TABLE [dbo].[Apresentacao] (
    [cd_apresentacao]       INT           NOT NULL,
    [nm_apresentacao]       VARCHAR (40)  NULL,
    [sg_apresentacao]       CHAR (10)     NULL,
    [ic_pad_apresentacao]   CHAR (1)      NULL,
    [ic_ativo_apresentacao] CHAR (1)      NULL,
    [nm_doc_apresentacao]   VARCHAR (100) NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Apresentacao] PRIMARY KEY CLUSTERED ([cd_apresentacao] ASC) WITH (FILLFACTOR = 90)
);

