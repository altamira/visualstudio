CREATE TABLE [dbo].[VE_Montador] (
    [vemo_Codigo]       INT           NOT NULL,
    [vemo_Descricao]    NVARCHAR (40) NULL,
    [vemo_porcentagem]  FLOAT (53)    NULL,
    [vemo_PorcMontador] TINYINT       NULL,
    [vemo_PorcAltamira] TINYINT       NULL,
    [vemo_PorcCliente]  TINYINT       NULL,
    [vemo_lock]         VARBINARY (8) NULL,
    CONSTRAINT [PK_VE_Montador] PRIMARY KEY NONCLUSTERED ([vemo_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Montador] TO [interclick]
    AS [dbo];

