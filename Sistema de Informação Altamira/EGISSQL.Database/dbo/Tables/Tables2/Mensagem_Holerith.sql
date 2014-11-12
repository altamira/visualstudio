CREATE TABLE [dbo].[Mensagem_Holerith] (
    [cd_mensagem_holerith] INT          NOT NULL,
    [nm_mensagem_holerith] VARCHAR (40) NULL,
    [sg_mensagem_holerith] CHAR (10)    NULL,
    [ic_ativa_mensagem]    CHAR (1)     NULL,
    [ds_mensagem]          TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Mensagem_Holerith] PRIMARY KEY CLUSTERED ([cd_mensagem_holerith] ASC) WITH (FILLFACTOR = 90)
);

