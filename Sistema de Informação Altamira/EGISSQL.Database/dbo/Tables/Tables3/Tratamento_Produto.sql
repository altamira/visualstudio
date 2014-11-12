CREATE TABLE [dbo].[Tratamento_Produto] (
    [cd_tratamento_produto] INT          NOT NULL,
    [nm_tratamento_produto] VARCHAR (40) NULL,
    [sg_tratamento_produto] CHAR (10)    NULL,
    [ds_tratamento_produto] TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [vl_tratamento_produto] FLOAT (53)   NULL,
    CONSTRAINT [PK_Tratamento_Produto] PRIMARY KEY CLUSTERED ([cd_tratamento_produto] ASC) WITH (FILLFACTOR = 90)
);

