package com.system.alba.model;

import com.system.alba.common.GenericMapper;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;

import java.util.List;

public class PageListDto {

    @Getter
    @Setter
    public static class Request {
        public static final int DEFAULT_PAGE_SIZE = 20;

        private int page;
        private int size;
        private String order;
        private Sort.Direction direction;

        public int getPage() {
            int _page = page;
            if (_page <= 0) _page = 0;
            return _page;
        }

        public int getSize() {
            return size <= 0 ? DEFAULT_PAGE_SIZE : size;
        }
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Response<T> {
        private long total;
        private int pages;
        private int page;
        private int size;
        private List<T> list;
        private boolean hasContent;

        public <Source> void pageToResponse(Page<Source> page, GenericMapper<T, Source> mapper) {
            List<Source> contents = page.getContent();
            List<T> list = mapper.sourceListToDestinationList(contents);
            this.total = page.getTotalElements();
            this.pages = page.getTotalPages();
            this.page = page.getPageable().getPageNumber() + 1;
            this.size = page.getSize();
            this.list = list;
            this.hasContent = page.hasContent();
        }

        public void pageToResponse(Page<T> page) {
            this.total = page.getTotalElements();
            this.pages = page.getTotalPages();
            this.page = page.getPageable().isPaged() ? page.getPageable().getPageNumber() + 1 : 0;
            this.size = page.getSize();
            this.list = page.getContent();
            this.hasContent = page.hasContent();
        }

    }

}
