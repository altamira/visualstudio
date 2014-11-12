CREATE TABLE [dbo].[Forum_Vara] (
    [cd_forum]              INT          NOT NULL,
    [cd_forum_vara]         INT          NOT NULL,
    [cd_identificacao_vara] VARCHAR (15) NULL,
    [nm_forum_vara]         VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Forum_Vara] PRIMARY KEY CLUSTERED ([cd_forum] ASC, [cd_forum_vara] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Forum_Vara_Forum] FOREIGN KEY ([cd_forum]) REFERENCES [dbo].[Forum] ([cd_forum])
);

