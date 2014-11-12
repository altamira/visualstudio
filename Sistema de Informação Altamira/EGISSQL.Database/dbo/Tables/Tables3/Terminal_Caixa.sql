CREATE TABLE [dbo].[Terminal_Caixa] (
    [cd_terminal_caixa]        INT          NOT NULL,
    [nm_terminal_caixa]        VARCHAR (40) NULL,
    [sg_terminal_caixa]        CHAR (10)    NULL,
    [cd_numero_terminal_caixa] VARCHAR (5)  NULL,
    [ic_status_terminal_caixa] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_loja]                  INT          NULL,
    CONSTRAINT [PK_Terminal_Caixa] PRIMARY KEY CLUSTERED ([cd_terminal_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Terminal_Caixa_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja])
);

