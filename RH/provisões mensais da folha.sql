select
    SRT010.RT_FILIAL,
    SRT010.RT_MAT,
    SRT010.RT_DATACAL,
    SRT010.RT_TIPPROV,
    SRT010.RT_VERBA,
    sum(SRT010.RT_DFERPRO),
    sum(SRT010.RT_VALOR),
    sum(SRT010.RT_VALOR) /
    case when SRT010.RT_VERBA = 830 then sum(isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5)
        else
        case when SRT010.RT_VERBA in (880, 890) then sum(isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5)
            else 0.0
        end
    end
from SRT010 (nolock)
where
        SRT010.D_E_L_E_T_ = ''
group by
    SRT010.RT_FILIAL,
    SRT010.RT_MAT,
    SRT010.RT_DATACAL,
    SRT010.RT_TIPPROV,
    SRT010.RT_VERBA,
