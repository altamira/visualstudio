CREATE TABLE [dbo].[Produto_Script] (
    [cd_produto] INT      NOT NULL,
    [cd_script]  INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Produto_Script] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_script] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Script_Script] FOREIGN KEY ([cd_script]) REFERENCES [dbo].[Script] ([cd_script])
);

