CREATE TABLE [dbo].[SPED_Livro] (
    [cd_livro]       INT          NOT NULL,
    [nm_livro]       VARCHAR (60) NULL,
    [qt_fonte_livro] FLOAT (53)   NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    [sg_livro]       CHAR (10)    NULL,
    CONSTRAINT [PK_SPED_Livro] PRIMARY KEY CLUSTERED ([cd_livro] ASC)
);

