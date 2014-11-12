CREATE TABLE [dbo].[Historico_Estoque] (
    [cd_historico_estoque]     INT          NOT NULL,
    [nm_historico_estoque]     VARCHAR (40) NOT NULL,
    [sg_historico_estoque]     CHAR (10)    NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_pad_historico_estoque] CHAR (1)     NULL,
    CONSTRAINT [PK_Historico_Estoque] PRIMARY KEY CLUSTERED ([cd_historico_estoque] ASC) WITH (FILLFACTOR = 90)
);

