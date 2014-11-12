CREATE TABLE [dbo].[varusrorc] (
    [varusrcodigo]    VARCHAR (100)   NOT NULL,
    [RECALCULAR]      BIT             NOT NULL,
    [numeroOrcamento] VARCHAR (9)     NOT NULL,
    [varusrvalor]     NVARCHAR (1024) NULL,
    CONSTRAINT [PK_varusrorc] PRIMARY KEY CLUSTERED ([varusrcodigo] ASC, [numeroOrcamento] ASC)
);

