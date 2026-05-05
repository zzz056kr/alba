package com.system.alba.service.common;

import com.system.alba.common.AppResultCode;
import com.system.alba.common.GenericMapper;
import com.system.alba.exception.ServerException;
import com.system.alba.model.PageListDto;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.DateTimePath;
import com.querydsl.jpa.JPQLQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.function.LongSupplier;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommonService {
    private final ThrowService throwService;

    public <Entity, Id> Entity getEntity(Id id, JpaRepository<Entity, Id> repository, String service, String category) throws ServerException {
        Entity entity = getEntity(id, repository, service, category, null, null);
        return entity;
    }

    public <Entity, Id> Entity getEntity(Id id, JpaRepository<Entity, Id> repository, String service, String category, String messageCode) throws ServerException {
        Entity entity = getEntity(id, repository, service, category, messageCode, null);
        return entity;
    }

    public <Entity, Id> Entity getEntity(Id id, JpaRepository<Entity, Id> repository, String service, String category, String messageCode, Object[] args) throws ServerException {
        Entity entity = repository.findById(id).orElse(null);
        if (entity == null)
            throw throwService.throwErrorByCode(service, category, AppResultCode.NOT_FOUND, null, messageCode, args);
        return entity;
    }

    public <Entity, Id, ReturnType> ReturnType get(Id id, JpaRepository<Entity, Id> repository, String service, String category, GenericMapper<ReturnType, Entity> mapper) throws ServerException {
        ReturnType data = get(id, repository, service, category, mapper, null, null);
        return data;
    }

    public <Entity, Id, ReturnType> ReturnType get(Id id, JpaRepository<Entity, Id> repository, String service, String category, GenericMapper<ReturnType, Entity> mapper, String messageCode) throws ServerException {
        ReturnType data = get(id, repository, service, category, mapper, messageCode, null);
        return data;
    }

    public <Entity, Id, ReturnType> ReturnType get(Id id, JpaRepository<Entity, Id> repository, String service, String category, GenericMapper<ReturnType, Entity> mapper, String messageCode, Object[] args) throws ServerException {
        Entity entity = getEntity(id, repository, service, category, messageCode, args);
        ReturnType data = mapper.sourceToDestination(entity);
        return data;
    }

    public Predicate between(DateTimePath<LocalDateTime> dateTimePath, LocalDate startDate, LocalDate endDate) {
        LocalDateTime start = startDate.atStartOfDay();
        LocalDateTime end = endDate.atTime(LocalTime.MAX);
        return dateTimePath.between(start, end);
    }

    public <Entity> void queryBetween(JPQLQuery<Entity> jpaQuery, DateTimePath<LocalDateTime> dateTimePath, LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null) return;
        jpaQuery.where(between(dateTimePath, startDate, endDate));
    }

    public <Entity> Page<Entity> page(JPQLQuery<Entity> contentQuery, LongSupplier countSupplier, PageListDto.Request pageListRequest) {
        return page(contentQuery, countSupplier, pageListRequest, null);
    }

    // count/content 쿼리를 분리해서 받아 fetchCount() deprecated 문제 해결
    // - contentQuery: orderBy/offset/limit이 적용될 content 전용 쿼리
    // - countSupplier: 별도로 빌드한 count 쿼리 (ex: countQuery::fetchOne)
    public <Entity> Page<Entity> page(JPQLQuery<Entity> contentQuery, LongSupplier countSupplier, PageListDto.Request pageListRequest, OrderSpecifier<?>[] orders) {
        int pageCount = Math.max(0, pageListRequest.getPage() - 1);
        int size = pageListRequest.getSize();

        Pageable pageable = PageRequest.of(pageCount, size);
        if (orders != null) contentQuery.orderBy(orders);
        List<?> list = contentQuery.offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        @SuppressWarnings("unchecked")
        Page<Entity> page = (Page<Entity>) PageableExecutionUtils.getPage(list, pageable, countSupplier);
        return page;
    }

    public <Entity, ReturnType> PageListDto.Response<ReturnType> pageToPageResponse(Page<Entity> page, GenericMapper<ReturnType, Entity> mapper) {
        PageListDto.Response<ReturnType> pageResponse = new PageListDto.Response<>();
        pageResponse.pageToResponse(page, mapper);
        return pageResponse;
    }

    @Transactional
    public <Entity, Id, ReturnType, Form> ReturnType save(JpaRepository<Entity, Id> repository, Form form, Entity instance, GenericMapper<Entity, Form> formMapper, GenericMapper<ReturnType, Entity> mapper) throws ServerException {
        formMapper.updateSourceToDestination(form, instance);
        instance = repository.save(instance);
        ReturnType data = mapper.sourceToDestination(instance);
        return data;
    }

    @Transactional
    public <Entity, Id, ReturnType, Form> ReturnType edit(Id id, JpaRepository<Entity, Id> repository, String SERVICE, String CATEGORY, String messageCode,
                                                          Form form, GenericMapper<Entity, Form> formMapper, GenericMapper<ReturnType, Entity> mapper) throws ServerException {
        Entity entity = getEntity(id, repository, SERVICE, CATEGORY, messageCode);

        formMapper.updateSourceToDestination(form, entity);
        entity = repository.save(entity);

        ReturnType detail = mapper.sourceToDestination(entity);
        return detail;
    }

    @Transactional
    public <Entity, Id, ReturnType> ReturnType delete(Id id, JpaRepository<Entity, Id> repository, String service, String category, GenericMapper<ReturnType, Entity> mapper) throws ServerException {
        Entity entity = getEntity(id, repository, service, category);
        repository.delete(entity);
        ReturnType data = mapper.sourceToDestination(entity);
        return data;
    }

}