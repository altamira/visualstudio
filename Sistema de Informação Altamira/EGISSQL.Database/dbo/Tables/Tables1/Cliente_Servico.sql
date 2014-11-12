CREATE TABLE [dbo].[Cliente_Servico] (
    [cd_cliente]         INT          NOT NULL,
    [cd_servico]         INT          NOT NULL,
    [vl_servico_cliente] FLOAT (53)   NULL,
    [nm_servico_cliente] VARCHAR (40) NULL,
    [ds_servico_cliente] TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Servico] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_servico] ASC) WITH (FILLFACTOR = 90)
);

