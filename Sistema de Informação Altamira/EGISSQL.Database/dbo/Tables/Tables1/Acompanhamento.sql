CREATE TABLE [dbo].[Acompanhamento] (
    [cd_acompanhamento]     INT          NOT NULL,
    [cd_contrato_concessao] INT          NULL,
    [dt_acompanhamento]     DATETIME     NULL,
    [ds_acompanhamento]     TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [nm_acompanhamento]     VARCHAR (25) NULL,
    [dt_retorno_acompan]    DATETIME     NULL,
    [nm_tel_retorno]        VARCHAR (15) NULL,
    CONSTRAINT [PK_Acompanhamento] PRIMARY KEY CLUSTERED ([cd_acompanhamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Acompanhamento_Contrato_Concessao] FOREIGN KEY ([cd_contrato_concessao]) REFERENCES [dbo].[Contrato_Concessao] ([cd_contrato])
);

