CREATE TABLE [dbo].[Clube_Jogos] (
    [cd_jogos]       INT          NOT NULL,
    [nm_jogos]       VARCHAR (60) NULL,
    [ic_ativo_jogos] CHAR (1)     NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Clube_Jogos] PRIMARY KEY CLUSTERED ([cd_jogos] ASC)
);

