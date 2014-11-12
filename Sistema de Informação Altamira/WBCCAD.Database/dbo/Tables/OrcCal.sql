CREATE TABLE [dbo].[OrcCal] (
    [idOrcCal]            INT           IDENTITY (1, 1) NOT NULL,
    [orccal_fator]        MONEY         NULL,
    [orccal_grupo]        INT           NULL,
    [orccal_nr_vezes]     INT           NULL,
    [orccal_tipo_calculo] NVARCHAR (30) NULL,
    [orccal_valor]        MONEY         NULL,
    [ORCCALTOTALLISTA]    MONEY         NULL,
    [ORCCALTOTALVENDA]    MONEY         NULL,
    [numeroOrcamento]     NCHAR (9)     NULL,
    CONSTRAINT [PK_OrcCal] PRIMARY KEY CLUSTERED ([idOrcCal] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcCal]
    ON [dbo].[OrcCal]([numeroOrcamento] ASC, [idOrcCal] ASC);

