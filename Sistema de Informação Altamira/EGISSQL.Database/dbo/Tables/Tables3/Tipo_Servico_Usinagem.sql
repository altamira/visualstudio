CREATE TABLE [dbo].[Tipo_Servico_Usinagem] (
    [cd_tipo_servico_usinagem] INT          NOT NULL,
    [nm_tipo_servico_usinagem] VARCHAR (40) NOT NULL,
    [sg_servico_usinagem]      CHAR (10)    NOT NULL,
    [cd_mao_obra]              INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Servico_Usinagem] PRIMARY KEY CLUSTERED ([cd_tipo_servico_usinagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Servico_Usinagem_Mao_Obra] FOREIGN KEY ([cd_mao_obra]) REFERENCES [dbo].[Mao_Obra] ([cd_mao_obra])
);

