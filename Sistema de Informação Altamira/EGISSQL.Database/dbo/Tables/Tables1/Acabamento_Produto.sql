CREATE TABLE [dbo].[Acabamento_Produto] (
    [cd_acabamento_produto] INT          NOT NULL,
    [nm_acabamento_produto] VARCHAR (40) NULL,
    [sg_acabamento_produto] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ds_acabamento_produto] TEXT         NULL,
    [vl_acabamento_produto] FLOAT (53)   NULL,
    CONSTRAINT [PK_Acabamento_Produto] PRIMARY KEY CLUSTERED ([cd_acabamento_produto] ASC) WITH (FILLFACTOR = 90)
);

