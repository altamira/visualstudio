CREATE TABLE [dbo].[Pacote] (
    [cd_pacote]           INT          NOT NULL,
    [nm_pacote]           VARCHAR (40) NULL,
    [ic_alteracao_pacote] CHAR (1)     NULL,
    [ds_pacote]           TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Pacote] PRIMARY KEY CLUSTERED ([cd_pacote] ASC) WITH (FILLFACTOR = 90)
);

