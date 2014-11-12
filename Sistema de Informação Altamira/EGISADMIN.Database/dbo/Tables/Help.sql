CREATE TABLE [dbo].[Help] (
    [cd_help]             INT          NOT NULL,
    [nm_help]             VARCHAR (40) NULL,
    [ds_help]             TEXT         NULL,
    [cd_imagem]           INT          NULL,
    [cd_usuario_atualiza] INT          NULL,
    [dt_atualiza]         DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([cd_help] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [XIF12Help]
    ON [dbo].[Help]([cd_imagem] ASC) WITH (FILLFACTOR = 90);

