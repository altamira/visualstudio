CREATE TABLE [dbo].[Emissora_Radio] (
    [cd_emissora_radio] INT          NOT NULL,
    [nm_emissora_radio] VARCHAR (60) NULL,
    [ic_tipo_radio]     CHAR (1)     NULL,
    [cd_fornecedor]     INT          NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Emissora_Radio] PRIMARY KEY CLUSTERED ([cd_emissora_radio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Emissora_Radio_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

