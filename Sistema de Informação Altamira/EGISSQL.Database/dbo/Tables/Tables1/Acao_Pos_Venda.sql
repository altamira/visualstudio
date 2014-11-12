CREATE TABLE [dbo].[Acao_Pos_Venda] (
    [cd_acao_pos_venda] INT          NOT NULL,
    [nm_acao_pos_venda] VARCHAR (40) NULL,
    [sg_acao_pos_venda] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Acao_Pos_Venda] PRIMARY KEY CLUSTERED ([cd_acao_pos_venda] ASC) WITH (FILLFACTOR = 90)
);

