CREATE TABLE [dbo].[Tipo_Viagem] (
    [cd_tipo_viagem]               INT          NOT NULL,
    [nm_tipo_viagem]               VARCHAR (30) NULL,
    [sg_tipo_viagem]               CHAR (10)    NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [ic_pad_tipo_viagem]           CHAR (1)     NULL,
    [cd_moeda]                     INT          NULL,
    [ic_informativo_tipo_viagem]   CHAR (1)     NULL,
    [ic_internacional_tipo_viagem] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Viagem] PRIMARY KEY CLUSTERED ([cd_tipo_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Viagem_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

