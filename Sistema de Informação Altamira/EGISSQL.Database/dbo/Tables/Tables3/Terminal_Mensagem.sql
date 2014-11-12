CREATE TABLE [dbo].[Terminal_Mensagem] (
    [cd_terminal_mensagem] INT          NOT NULL,
    [nm_terminal_mensagem] VARCHAR (50) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_rodape_cupom]      CHAR (1)     NULL,
    CONSTRAINT [PK_Terminal_Mensagem] PRIMARY KEY CLUSTERED ([cd_terminal_mensagem] ASC) WITH (FILLFACTOR = 90)
);

